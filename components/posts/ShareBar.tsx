'use client'

import { Post } from '@/lib/posts'

interface ShareBarProps {
  post: Post
}

export default function ShareBar({ post }: ShareBarProps) {
  const url = typeof window !== 'undefined' 
    ? window.location.href 
    : `https://nambrot.com/posts/${post.slug}`
  
  const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(post.title)}&url=${encodeURIComponent(url)}`
  const facebookUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`
  const linkedinUrl = `https://www.linkedin.com/shareArticle?mini=true&url=${encodeURIComponent(url)}&title=${encodeURIComponent(post.title)}`

  return (
    <div id="blog_share_bar" style={{ marginTop: '20px', marginBottom: '20px' }}>
      <span style={{ marginRight: '10px' }}>Share:</span>
      <a 
        href={twitterUrl} 
        target="_blank" 
        rel="noopener noreferrer"
        style={{ marginRight: '10px' }}
      >
        Twitter
      </a>
      <a 
        href={facebookUrl} 
        target="_blank" 
        rel="noopener noreferrer"
        style={{ marginRight: '10px' }}
      >
        Facebook
      </a>
      <a 
        href={linkedinUrl} 
        target="_blank" 
        rel="noopener noreferrer"
      >
        LinkedIn
      </a>
    </div>
  )
}
