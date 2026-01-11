import Link from 'next/link'
import { Post } from '@/lib/posts'

interface PostCardProps {
  post: Post
}

function formatDate(dateString: string): string {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

export default function PostCard({ post }: PostCardProps) {
  return (
    <article id={`blog_post_${post.id}`} className="blog_post index">
      <header>
        <h1>
          <Link href={`/posts/${post.slug}`}>{post.title}</Link>
        </h1>
      </header>
      <h6>
        {formatDate(post.created_at)}
        {post.tags.length > 0 && (
          <>
            {' | '}
            {post.tags.map((tag, index) => (
              <span key={tag}>
                <Link href={`/?tags=${encodeURIComponent(tag)}`}>{tag}</Link>
                {index < post.tags.length - 1 && ', '}
              </span>
            ))}
          </>
        )}
      </h6>
      <p>{post.summary}</p>
      <div className="blog_post_spacer" />
    </article>
  )
}
