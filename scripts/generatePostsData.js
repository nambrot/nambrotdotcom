const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

function slugify(text) {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/--+/g, '-')
    .trim();
}

const dataDirectory = path.join(__dirname, '..', 'data');
const yamlPath = path.join(dataDirectory, 'posts.yaml');
const fileContents = fs.readFileSync(yamlPath, 'utf8');
const posts = yaml.load(fileContents);

const postsWithSlugs = posts
  .map((post) => ({
    ...post,
    tags: post.tags || [],
    slug: `${post.id}-${slugify(post.title)}`,
  }))
  .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());

const output = `// Auto-generated file - do not edit manually
import { Post } from '@/lib/posts';

const postsData: Post[] = ${JSON.stringify(postsWithSlugs, null, 2)};

export default postsData;
`;

fs.writeFileSync(path.join(dataDirectory, 'postsData.ts'), output);
console.log('Generated postsData.ts');
