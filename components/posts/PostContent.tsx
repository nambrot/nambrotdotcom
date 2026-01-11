import { Post } from '@/lib/posts'

interface PostContentProps {
  post: Post
  htmlContent: string
}

function formatDate(dateString: string): string {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

export default function PostContent({ post, htmlContent }: PostContentProps) {
  return (
    <article id={`blog_post_${post.id}`} className="blog_post">
      <div className="blog_post_header">
        <h1>{post.title}</h1>
        <h6>
          {formatDate(post.created_at)}
          {post.tags.length > 0 && (
            <>
              {' | '}
              {post.tags.join(', ')}
            </>
          )}
        </h6>
      </div>
      <div 
        className="blog_post_body"
        dangerouslySetInnerHTML={{ __html: htmlContent }} 
      />
    </article>
  )
}
