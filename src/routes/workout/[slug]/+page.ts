// Sibling file for svelte page that loads in slug params such that page can
// use the data
import type { PageLoad } from "./$types";

export const load = (({ params }) => {
  return {
    post: {
      params: `Slug: ${params.slug}`
    }
  };
}) satisfies PageLoad;
