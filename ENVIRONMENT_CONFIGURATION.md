# Environment Configuration Guide

## Overview
This document explains how the MAQSoftware website handles different environments (production and beta/dev) to ensure links and meta tags are correctly configured for each environment.

## Problem
Previously, the website had hardcoded links to `https://maqsoftware.com` throughout the codebase. When deploying to the beta site (`https://maqsoftware-beta.netlify.app`), these hardcoded links would redirect users back to the main production site instead of staying within the beta environment.

## Solution
We've implemented an automatic environment detection and configuration system that:
1. Detects which environment the site is running on
2. Automatically updates internal links to use the correct base URL
3. Updates meta tags, canonical URLs, and social sharing tags for SEO

## How It Works

### 1. Configuration Script (`/js/config.js`)
This script automatically loads on every page and:
- Detects the current hostname
- Sets the appropriate base URL (`https://maqsoftware.com` for production, current origin for beta)
- Provides utility functions for generating URLs
- Automatically updates meta tags when on beta/dev sites

### 2. Relative Paths in Navigation
Header and footer navigation menus now use relative paths (`/services/...` instead of `https://maqsoftware.com/services/...`), which automatically work on both environments.

### 3. Automatic Meta Tag Updates
When the site loads on a beta/dev environment, the config script automatically updates:
- Canonical links
- Open Graph URLs
- Sitemap references
- Alternate language links

## Files Modified

### Core Configuration
- **`/js/config.js`** - Main configuration script (NEW)
- **`/header.html`** - Updated all navigation links to use relative paths
- **`/footer.html`** - Updated all navigation links to use relative paths

### Pages Updated
- **`/index.html`** - Added config.js script
- **`/AI-DataLens.html`** - Added config.js script
- More pages will be updated to include config.js

## Usage

### For Developers

#### Including config.js in a Page
Add this script tag after jQuery but before other custom scripts:
```html
<script src="/js/config.js"></script>
```

#### Using the Config in JavaScript
```javascript
// Get the base URL for the current environment
var baseURL = MAQConfig.baseURL;
// Returns: "https://maqsoftware.com" on production
// Returns: "https://maqsoftware-beta.netlify.app" on beta

// Generate a full URL
var fullURL = MAQConfig.getURL('services/artificial-intelligence');
// Returns: "https://maqsoftware.com/services/artificial-intelligence" on production
// Returns: "https://maqsoftware-beta.netlify.app/services/artificial-intelligence" on beta

// Check if running on beta
if (MAQConfig.isBeta()) {
    console.log("Running on beta environment");
}
```

#### Creating Internal Links in HTML
**Preferred approach:** Use relative paths
```html
<!-- Good - will work on both environments -->
<a href="/services/artificial-intelligence">Services</a>
<a href="/case-studies">Case Studies</a>

<!-- Avoid - hardcoded production URLs -->
<a href="https://maqsoftware.com/services">Services</a>
```

## Environment Detection

The script considers these environments as beta/dev:
- `maqsoftware-beta.netlify.app`
- `localhost`
-  `127.0.0.1`

Any other hostname is treated as production and will use `https://maqsoftware.com` as the base URL.

## Meta Tags Behavior

### On Production
Meta tags remain unchanged and point to production URLs.

### On Beta/Dev
The following meta tags are automatically updated to use beta URLs:
- `<link rel="canonical">` - Updated to current page URL on beta
- `<meta property="og:url">` - Updated to current page URL on beta
- `<link rel="sitemap">` - Points to beta sitemap
- `<link rel="alternate" hreflang="...">` - Updated to beta URLs

**Note:** Open Graph image URLs (`og:image`) intentionally remain pointing to production to ensure social media previews display correctly, as beta images may not be publicly accessible.

## Testing

### Test on Beta Site
1. Deploy to `maqsoftware-beta.netlify.app`
2. Open browser console
3. Check for log: `MAQConfig initialized: https://maqsoftware-beta.netlify.app`
4. Verify navigation links stay within the beta site
5. Verify canonical and OG URLs in page source point to beta

### Test on Production
1. Deploy to `maqsoftware.com`
2. Open browser console
3. Check for log: `MAQConfig initialized: https://maqsoftware.com`
4. Verify all links point to production
5. Verify meta tags have production URLs

## Troubleshooting

### Links Still Redirect to Production
- Check if the page includes `<script src="/js/config.js"></script>`
- Verify the link is using relative path (`/page`) not absolute (`https://maqsoftware.com/page`)
- Check browser console for any JavaScript errors

### Meta Tags Not Updating
- Ensure config.js is loaded in the page
- Check browser console for: `Meta tags updated for beta environment`
- Verify page is actually running on a beta/dev domain

### Config Not Loading
- Verify the path to config.js is correct
- Check browser console for 404 errors
- Ensure config.js is deployed with the site

## Future Updates

As you add new pages or modify existing ones:
1. **Always use relative paths** for internal links (e.g., `/contact` not `https://maqsoftware.com/contact`)
2. **Include config.js** in the page's script section
3. **Avoid hardcoding** production URLs except for:
   - External references that should always point to production
   - Image URLs for social media sharing
   - Schema.org markup that requires production URLs

## Deployment Checklist

Before deploying to beta:
- [ ] Verify config.js is included in pages
- [ ] Check navigation uses relative paths
- [ ] Test a few pages to ensure links work
- [ ] Verify meta tags update correctly

Before deploying to production:
- [ ] Run same tests as beta
- [ ] Verify production URLs are used when not on beta
- [ ] Test social media sharing previews

## Questions or Issues?
Contact the development team for assistance with environment configuration.
