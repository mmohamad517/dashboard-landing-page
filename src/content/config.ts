import { defineCollection, z } from 'astro:content';

const articles = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    keyword: z.string(),
    pubDate: z.date(),
    updatedDate: z.date(),
    author: z.string().default('BestOutDoorWears Editorial'),
    relatedSlugs: z.array(z.string()).default([]),
  }),
});

export const collections = { articles };
