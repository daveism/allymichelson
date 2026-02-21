import type { Metadata } from 'next';
import { getContactContent } from '@/lib/content';
import ContactForm from '@/components/ui/ContactForm';

export const metadata: Metadata = { title: 'Contact' };

export default async function ContactPage() {
  const contact = await getContactContent();

  return (
    <div className="px-8 py-16 max-w-3xl mx-auto">
      <h1 className="font-heading text-4xl mb-4 organic-line">Contact</h1>
      <div className="prose-custom mt-8 mb-12" dangerouslySetInnerHTML={{ __html: contact.content }} />
      <ContactForm formspreeId={contact.formspreeId} />
    </div>
  );
}
