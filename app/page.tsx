'use client';

import { useSearchParams } from 'next/navigation';
import { Suspense } from 'react';
import PostCard from '@/components/posts/PostCard';
import { Post } from '@/lib/posts';

// We need to import the posts data at build time
// Since we can't use the fs module in client components,
// we'll create a separate data file
import postsData from '@/data/postsData';

function PostsList() {
  const searchParams = useSearchParams();
  const tag = searchParams.get('tags');
  
  const posts = tag 
    ? postsData.filter((post: Post) => post.tags?.includes(tag))
    : postsData;

  return (
    <main>
      {tag && (
        <h4>Posts tagged &apos;{tag}&apos;</h4>
      )}
      {posts.map((post: Post) => (
        <PostCard key={post.id} post={post} />
      ))}
    </main>
  );
}

export default function Home() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <PostsList />
    </Suspense>
  );
}
