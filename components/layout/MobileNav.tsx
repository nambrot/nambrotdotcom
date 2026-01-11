'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function MobileNav() {
  const [isOpen, setIsOpen] = useState(false)

  const toggleMenu = () => {
    setIsOpen(!isOpen)
  }

  const closeMenu = () => {
    setIsOpen(false)
  }

  return (
    <>
      <aside id="global-nav-mobile">
        <a href="#" onClick={(e) => { e.preventDefault(); toggleMenu(); }}>
          <span className="hamburger-icon">
            <span></span>
            <span></span>
            <span></span>
          </span>
          nambrot.com
        </a>
      </aside>

      {/* Mobile menu overlay */}
      <div 
        className={`menu-overlay ${isOpen ? 'open' : ''}`} 
        onClick={closeMenu}
      />

      {/* Mobile sidebar - uses same styles as desktop but with open class */}
      <aside
        id="global-nav"
        className={isOpen ? 'open' : ''}
        style={{ backgroundImage: "url('/images/IMG_4771.jpg')" }}
      >
        <header>
          <h2>
            <Link href="/" onClick={closeMenu}>nambrot.com</Link>
          </h2>
          <h5>Nam Chu Hoai doing things that you can read about</h5>
        </header>
        <nav>
          <ul>
            <li><Link href="/about" onClick={closeMenu}>About</Link></li>
            <li><Link href="/hire" onClick={closeMenu}>Hire Me</Link></li>
            <li><Link href="/" onClick={closeMenu}>Blog</Link></li>
            <li><Link href="/aroundtheworld" onClick={closeMenu}>Around the World</Link></li>
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
              <Link href="/resume" onClick={closeMenu}>
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
    </>
  )
}
