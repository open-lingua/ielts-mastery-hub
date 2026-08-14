import type { ReactNode } from 'react';
import Layout from '@theme/Layout';
import Hero from '@site/src/components/HomepageSections/Hero';
import TrustStrip from '@site/src/components/HomepageSections/TrustStrip';
import AudienceSection from '@site/src/components/HomepageSections/AudienceSection';
import FeaturesSection from '@site/src/components/HomepageSections/FeaturesSection';
import ShowcaseSection from '@site/src/components/HomepageSections/ShowcaseSection';
import StepsSection from '@site/src/components/HomepageSections/StepsSection';
import TechStackSection from '@site/src/components/HomepageSections/TechStackSection';
import FinalCta from '@site/src/components/HomepageSections/FinalCta';

export default function Home(): ReactNode {
  return (
    <Layout
      title="IELTS Mastery Hub — Prepare the way you'll sit it"
      description="A native desktop trainer for IELTS: timed reading and listening, AI-graded writing, realistic exam simulations, and progress you can actually see."
    >
      <main>
        <Hero />
        <TrustStrip />
        <AudienceSection />
        <FeaturesSection />
        <ShowcaseSection />
        <StepsSection />
        <TechStackSection />
        <FinalCta />
      </main>
    </Layout>
  );
}
