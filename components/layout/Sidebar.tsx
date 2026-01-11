'use client'

import Link from 'next/link'

export default function Sidebar() {
  return (
    <aside
      id="global-nav"
      style={{ backgroundImage: "url('/images/IMG_4771.jpg')" }}
    >
      <header>
        <h2>
          <Link href="/">nambrot.com</Link>
        </h2>
        <h5>Nam Chu Hoai doing things that you can read about</h5>
      </header>
      <nav>
        <ul>
          <li><Link href="/about">About</Link></li>
          <li><Link href="/hire">Hire Me</Link></li>
          <li><Link href="/">Blog</Link></li>
          <li><Link href="/aroundtheworld">Around the World</Link></li>
        </ul>
        <ul>
          <li>
            <a href="https://www.facebook.com/namchuhoai" rel="me">
              <span className="social-icon facebook-icon"></span>
              /namchuhoai
            </a>
          </li>
          <li>
            <a href="https://www.twitter.com/nambrot" rel="me">
              <span className="social-icon twitter-icon"></span>
              @nambrot
            </a>
          </li>
          <li>
            <a href="http://www.linkedin.com/in/namchuhoai/en" rel="me">
              <span className="social-icon linkedin-icon"></span>
              /namchuhoai
            </a>
          </li>
          <li>
            <a href="https://github.com/nambrot" rel="me">
              <span className="social-icon github-icon"></span>
              /nambrot
            </a>
          </li>
          <li>
            <Link href="/resume">
              <span className="social-icon github-icon"></span>
              Resume
            </Link>
          </li>
          <li>
            <a href="mailto:nam@nambrot.com">
              <span className="social-icon email-icon"></span>
              nam@nambrot.com
            </a>
          </li>
        </ul>
      </nav>
    </aside>
  )
}
