'use client';

import { useState, FormEvent } from 'react';

interface ContactFormProps {
  variant: 'hire' | 'fire' | 'message';
}

export default function ContactForm({ variant }: ContactFormProps) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [message, setMessage] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    // Non-functional - just show success message
    setSubmitted(true);
  };

  return (
    <form onSubmit={handleSubmit} className="contact-form">
      <div className="form-field">
        <label htmlFor={`${variant}-name`}>
          Name:
          <input
            type="text"
            id={`${variant}-name`}
            name="Name"
            placeholder="Mark Zuckerberg"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </label>
      </div>

      <div className="form-field">
        <label htmlFor={`${variant}-email`}>
          Email:
          <input
            type="email"
            id={`${variant}-email`}
            name="Email"
            placeholder="zuckdog@fb.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </label>
      </div>

      <div className="form-field">
        <label htmlFor={`${variant}-message`}>Message:</label>
        <textarea
          id={`${variant}-message`}
          name="Message"
          rows={7}
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          required
        />
      </div>

      <button type="submit" className="button round">
        Submit
      </button>

      {submitted && (
        <div className="alert-box">
          Thank You, I will be in contact shortly.
          <button type="button" className="close" onClick={() => setSubmitted(false)}>
            &times;
          </button>
        </div>
      )}
    </form>
  );
}
