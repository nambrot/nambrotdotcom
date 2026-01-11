import { notFound } from 'next/navigation'
import { getPostBySlug, getAllPostSlugs } from '@/lib/posts'
import { markdownToHtml } from '@/lib/markdown'
import PostContent from '@/components/posts/PostContent'
import ShareBar from '@/components/posts/ShareBar'
import DisqusComments from '@/components/posts/DisqusComments'
import { Metadata } from 'next'

interface PostPageProps {
  params: { slug: string }
}

export async function generateStaticParams() {
  const slugs = getAllPostSlugs()
  return slugs.map((slug) => ({ slug }))
}

export async function generateMetadata({ params }: PostPageProps): Promise<Metadata> {
  const post = getPostBySlug(params.slug)
  if (!post) {
    return { title: 'Post Not Found' }
  }
  return {
    title: post.title,
    description: post.summary,
  }
}

export default async function PostPage({ params }: PostPageProps) {
  const post = getPostBySlug(params.slug)

  if (!post) {
    notFound()
  }

  const htmlContent = post.body ? await markdownToHtml(post.body) : ''
  const postUrl = `https://nambrot.com/posts/${post.slug}`

  return (
    <main>
      <PostContent post={post} htmlContent={htmlContent} />
      <ShareBar post={post} />
      <DisqusComments
        shortname="nambrot"
        identifier={String(post.id)}
        title={post.title}
        url={postUrl}
      />
    </main>
  )
}
