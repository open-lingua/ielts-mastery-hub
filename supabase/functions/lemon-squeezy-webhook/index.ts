import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-signature, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version',
}

async function verifySignature(payload: string, signature: string, secret: string): Promise<boolean> {
  const encoder = new TextEncoder()
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  )
  const signatureBytes = await crypto.subtle.sign('HMAC', key, encoder.encode(payload))
  const computedSignature = Array.from(new Uint8Array(signatureBytes))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('')
  return computedSignature === signature
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    const webhookSecret = Deno.env.get('LEMON_SQUEEZY_WEBHOOK_SECRET')
    if (!webhookSecret) {
      console.error('LEMON_SQUEEZY_WEBHOOK_SECRET is not configured')
      return new Response(
        JSON.stringify({ error: 'Webhook secret not configured' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const rawBody = await req.text()
    const signature = req.headers.get('x-signature')

    if (!signature) {
      console.error('Missing x-signature header')
      return new Response(
        JSON.stringify({ error: 'Missing signature' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const isValid = await verifySignature(rawBody, signature, webhookSecret)
    if (!isValid) {
      console.error('Invalid webhook signature')
      return new Response(
        JSON.stringify({ error: 'Invalid signature' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const payload = JSON.parse(rawBody)
    const eventName = payload.meta?.event_name
    const customData = payload.meta?.custom_data || {}
    const userEmail = customData.user_email

    console.log(`Received Lemon Squeezy event: ${eventName}`)
    console.log(`User email from custom_data: ${userEmail}`)

    if (!userEmail) {
      console.error('Missing user_email in custom_data')
      return new Response(
        JSON.stringify({ error: 'Missing user_email in custom_data' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('id, email')
      .eq('email', userEmail)
      .maybeSingle()

    if (profileError) {
      console.error('Error fetching profile:', profileError)
      return new Response(
        JSON.stringify({ error: 'Error fetching user profile' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (!profile) {
      console.error(`User not found for email: ${userEmail}`)
      return new Response(
        JSON.stringify({ error: 'User not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    async function getPlanIdFromVariant(variantId: string | null): Promise<string | null> {
      if (!variantId) return null
      const { data: plan, error } = await supabaseAdmin
        .from('plans')
        .select('id')
        .eq('lemon_squeezy_variant_id', variantId)
        .maybeSingle()
      if (error) {
        console.error('Error looking up plan by variant_id:', error)
        return null
      }
      return plan?.id || null
    }

    async function getSubscriptionByLemonSqueezyId(lsSubscriptionId: string): Promise<string | null> {
      const { data: subscription, error } = await supabaseAdmin
        .from('subscriptions')
        .select('id')
        .eq('lemon_squeezy_subscription_id', lsSubscriptionId)
        .maybeSingle()
      if (error) {
        console.error('Error looking up subscription:', error)
        return null
      }
      return subscription?.id || null
    }

    switch (eventName) {
      case 'subscription_created':
      case 'subscription_updated': {
        const subscriptionData = payload.data?.attributes
        const subscriptionId = payload.data?.id
        const variantId = subscriptionData?.variant_id?.toString()
        const planId = await getPlanIdFromVariant(variantId)
        console.log(`Variant ID: ${variantId}, Plan ID: ${planId}`)

        const { error: subError } = await supabaseAdmin
          .from('subscriptions')
          .upsert({
            user_id: profile.id,
            user_email: userEmail,
            lemon_squeezy_subscription_id: subscriptionId,
            lemon_squeezy_customer_id: subscriptionData?.customer_id?.toString(),
            lemon_squeezy_order_id: subscriptionData?.order_id?.toString(),
            status: subscriptionData?.status || 'active',
            variant_id: variantId,
            plan_id: planId,
            current_period_start: subscriptionData?.created_at ? new Date(subscriptionData.created_at).toISOString() : null,
            current_period_end: subscriptionData?.renews_at ? new Date(subscriptionData.renews_at).toISOString() : null,
            cancelled_at: subscriptionData?.cancelled_at ? new Date(subscriptionData.cancelled_at).toISOString() : null,
          }, {
            onConflict: 'lemon_squeezy_subscription_id',
            ignoreDuplicates: false,
          })

        if (subError) {
          console.error('Error upserting subscription:', subError)
          return new Response(
            JSON.stringify({ error: 'Error saving subscription' }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }

        console.log(`Subscription ${eventName === 'subscription_created' ? 'created' : 'updated'} for ${userEmail}`)
        break
      }

      case 'order_created': {
        const orderData = payload.data?.attributes
        const orderId = payload.data?.id
        const firstOrderItem = orderData?.first_order_item
        const variantId = firstOrderItem?.variant_id?.toString() || orderData?.variant_id?.toString()
        const totalInCents = orderData?.total || orderData?.subtotal || firstOrderItem?.price || 0
        const amount = typeof totalInCents === 'number' ? totalInCents / 100 : parseFloat(totalInCents) / 100
        const planId = await getPlanIdFromVariant(variantId)
        console.log(`Order Variant ID: ${variantId}, Plan ID: ${planId}, Amount: ${amount}`)

        let subscriptionDbId: string | null = null
        const lsSubscriptionId = orderData?.first_subscription_item?.subscription_id?.toString()
        if (lsSubscriptionId) {
          subscriptionDbId = await getSubscriptionByLemonSqueezyId(lsSubscriptionId)
        }

        const paymentMethod = orderData?.card_brand || orderData?.payment_method || null

        const { error: paymentError } = await supabaseAdmin
          .from('payments')
          .insert({
            user_id: profile.id,
            user_email: userEmail,
            lemon_squeezy_order_id: orderId,
            lemon_squeezy_payment_id: orderId,
            subscription_id: subscriptionDbId,
            plan_id: planId,
            amount: amount,
            currency: (orderData?.currency || 'USD').toUpperCase(),
            status: orderData?.status === 'paid' ? 'completed' : 'pending',
            payment_method: paymentMethod,
            receipt_url: orderData?.urls?.receipt || null,
          })

        if (paymentError) {
          console.error('Error creating payment:', paymentError)
          return new Response(
            JSON.stringify({ error: 'Error saving payment' }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }

        console.log(`Payment recorded for order ${orderId} - ${userEmail} - Amount: ${amount}`)
        break
      }

      default:
        console.log(`Unhandled event type: ${eventName}`)
    }

    return new Response(
      JSON.stringify({ success: true, event: eventName }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Webhook processing error:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
