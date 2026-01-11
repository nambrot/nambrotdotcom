import fs from 'fs'
import path from 'path'
import yaml from 'js-yaml'

export interface Post {
  id: number
  title: string
  summary: string
  tags: string[]
  created_at: string
  slug: string
  body?: string
}

interface PostYaml {
  id: number
  title: string
  summary: string
  tags: string[]
  created_at: string
}

const postsDirectory = path.join(process.cwd(), 'content/posts')
const dataDirectory = path.join(process.cwd(), 'data')

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/--+/g, '-')
    .trim()
}

export function getAllPosts(): Post[] {
  const yamlPath = path.join(dataDirectory, 'posts.yaml')
  const fileContents = fs.readFileSync(yamlPath, 'utf8')
  const posts = yaml.load(fileContents) as PostYaml[]

  return posts
    .map((post) => ({
      ...post,
      tags: post.tags || [],
      slug: `${post.id}-${slugify(post.title)}`,
    }))
    .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
}

export function getPostBySlug(slug: string): Post | undefined {
  const posts = getAllPosts()
  const id = parseInt(slug.split('-')[0], 10)
  const post = posts.find((p) => p.id === id)
  
  if (!post) return undefined

  const markdownPath = path.join(postsDirectory, `${id}.md`)
  
  if (fs.existsSync(markdownPath)) {
    const body = fs.readFileSync(markdownPath, 'utf8')
    return { ...post, body }
  }

  return post
}

export function getPostsByTag(tag: string): Post[] {
  const posts = getAllPosts()
  return posts.filter((post) => post.tags.includes(tag))
}

export function getAllTags(): string[] {
  const posts = getAllPosts()
  const tagsSet = new Set<string>()
  posts.forEach((post) => {
    post.tags.forEach((tag) => tagsSet.add(tag))
  })
  return Array.from(tagsSet).sort()
}

export function getAllPostSlugs(): string[] {
  const posts = getAllPosts()
  return posts.map((post) => post.slug)
}
