
-- Add ban-related columns to profiles
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS is_banned boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS ban_reason text,
  ADD COLUMN IF NOT EXISTS banned_until timestamp with time zone;

-- Allow super_admins to view all profiles (already have public SELECT policy)
-- Allow super_admins to update any profile (for banning, plan changes)
CREATE POLICY "Super admins can update any profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (public.has_role(auth.uid(), 'super_admin'));

-- Allow super_admins to delete profiles
CREATE POLICY "Super admins can delete any profile"
  ON public.profiles
  FOR DELETE
  TO authenticated
  USING (public.has_role(auth.uid(), 'super_admin'));

-- Allow super_admins to read user_roles (needed to display roles in admin UI)
CREATE POLICY "Super admins can view all roles"
  ON public.user_roles
  FOR SELECT
  TO authenticated
  USING (public.has_role(auth.uid(), 'super_admin'));

-- Allow super_admins to insert roles
CREATE POLICY "Super admins can insert roles"
  ON public.user_roles
  FOR INSERT
  TO authenticated
  WITH CHECK (public.has_role(auth.uid(), 'super_admin'));

-- Allow super_admins to update roles
CREATE POLICY "Super admins can update roles"
  ON public.user_roles
  FOR UPDATE
  TO authenticated
  USING (public.has_role(auth.uid(), 'super_admin'));

-- Allow super_admins to delete roles
CREATE POLICY "Super admins can delete roles"
  ON public.user_roles
  FOR DELETE
  TO authenticated
  USING (public.has_role(auth.uid(), 'super_admin'));
