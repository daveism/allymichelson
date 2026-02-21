'use client';

import { useState } from 'react';

interface Props {
  formspreeId: string;
}

export default function ContactForm({ formspreeId }: Props) {
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent' | 'error'>('idle');

  async function handleSubmit() {
    setStatus('sending');
    const form = document.getElementById('contact-form') as HTMLElement;
    const inputs = form.querySelectorAll('input, textarea') as NodeListOf<HTMLInputElement | HTMLTextAreaElement>;
    const formData = new FormData();
    inputs.forEach(inp => { if (inp.name) formData.append(inp.name, inp.value); });

    try {
      const res = await fetch(`https://formspree.io/f/${formspreeId}`, {
        method: 'POST',
        body: formData,
        headers: { Accept: 'application/json' },
      });
      if (res.ok) {
        setStatus('sent');
        inputs.forEach(i => { i.value = ''; });
      } else {
        setStatus('error');
      }
    } catch {
      setStatus('error');
    }
  }

  if (status === 'sent') {
    return (
      <div className="bg-surface border border-border rounded-card p-8 text-center">
        <p className="text-accent-primary font-accent text-lg">Message sent!</p>
        <p className="text-text-secondary mt-2">Thank you for reaching out.</p>
        <button onClick={() => setStatus('idle')} className="btn btn-secondary mt-4">
          Send another
        </button>
      </div>
    );
  }

  const inputClass = `w-full bg-surface border border-border rounded-btn px-4 py-3 text-text-primary
    focus:border-accent-primary focus:outline-none focus:ring-1 focus:ring-focus transition-colors`;

  return (
    <div id="contact-form" className="flex flex-col gap-4">
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label htmlFor="name" className="block text-text-secondary text-sm mb-1 font-accent">Name</label>
          <input type="text" id="name" name="name" required className={inputClass} />
        </div>
        <div>
          <label htmlFor="email" className="block text-text-secondary text-sm mb-1 font-accent">Email</label>
          <input type="email" id="email" name="email" required className={inputClass} />
        </div>
      </div>
      <div>
        <label htmlFor="subject" className="block text-text-secondary text-sm mb-1 font-accent">Subject</label>
        <input type="text" id="subject" name="subject" className={inputClass} />
      </div>
      <div>
        <label htmlFor="message" className="block text-text-secondary text-sm mb-1 font-accent">Message</label>
        <textarea id="message" name="message" rows={6} required className={`${inputClass} resize-none`} />
      </div>
      <button
        type="button"
        disabled={status === 'sending'}
        onClick={handleSubmit}
        className="btn btn-primary self-start"
      >
        {status === 'sending' ? 'Sending...' : 'Send Message'}
      </button>
      {status === 'error' && (
        <p className="text-error text-sm">Something went wrong. Please try again.</p>
      )}
    </div>
  );
}
