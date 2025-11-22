# Web Development Domain Module

## 🎯 Applies To Projects
- **website2.0**: Personal portfolio with canvas animations
- **leen**: Bilingual artist portfolio with GSAP
- **Karazah-Website**: Educational channel website
- **invoices**: Invoice generation system

## 🌐 Domain-Specific Agent Enhancements

### Agent 4: System Architect (Web Enhanced)
- **Responsive Design First**: Mobile-first, progressive enhancement
- **Performance Architecture**: Core Web Vitals optimization from start
- **Accessibility Integration**: WCAG 2.1 AA compliance in architecture
- **SEO Structure**: Semantic HTML5, meta optimization, structured data

### Agent 7: Code Generator (Web Enhanced)
- **Modern Web Standards**: HTML5, CSS3, ES6+ JavaScript
- **Framework Patterns**: Component-based architecture when appropriate
- **Progressive Enhancement**: Core functionality without JavaScript
- **Cross-Browser Compatibility**: Support modern browsers (Chrome 90+, Firefox 88+, Safari 14+)

### Agent 11: Performance Optimizer (Web Enhanced)
- **Core Web Vitals**: LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Asset Optimization**: Image compression, lazy loading, font optimization
- **Critical Path**: Inline critical CSS, defer non-critical resources
- **Caching Strategies**: Browser caching, CDN optimization

## 🎨 Design System Standards

### Typography Hierarchy
```css
/* Primary Heading */
h1 { font-size: clamp(2rem, 5vw, 3.5rem); }

/* Secondary Heading */  
h2 { font-size: clamp(1.5rem, 4vw, 2.5rem); }

/* Body Text */
p { font-size: clamp(1rem, 2.5vw, 1.125rem); }

/* Mobile-first responsive scaling */
```

### Color Accessibility
- **Contrast Ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
- **Color Blindness**: Test with tools, never rely on color alone
- **Dark Mode**: Provide alternative color schemes when possible

### Component Architecture
```html
<!-- Semantic, accessible component structure -->
<article class="card" role="article" aria-labelledby="card-title">
    <header>
        <h2 id="card-title">Card Title</h2>
    </header>
    <div class="card-content">
        <p>Descriptive content with proper hierarchy</p>
    </div>
    <footer>
        <button type="button" aria-label="Learn more about Card Title">
            Learn More
        </button>
    </footer>
</article>
```

## 📱 Responsive Design Patterns

### Breakpoint Strategy
```css
/* Mobile First Approach */
.container {
    padding: 1rem;
    max-width: 100%;
}

/* Tablet */
@media (min-width: 768px) {
    .container {
        padding: 2rem;
        max-width: 750px;
    }
}

/* Desktop */
@media (min-width: 1200px) {
    .container {
        padding: 3rem;
        max-width: 1140px;
    }
}
```

### Layout Patterns
- **CSS Grid**: For two-dimensional layouts
- **Flexbox**: For one-dimensional layouts and alignment
- **Container Queries**: When supported, for component-based responsive design

## ⚡ Performance Optimization

### Critical Performance Metrics
```javascript
// Core Web Vitals monitoring
new PerformanceObserver((entryList) => {
    for (const entry of entryList.getEntries()) {
        console.log('Performance metric:', entry.name, entry.value);
    }
}).observe({entryTypes: ['largest-contentful-paint', 'first-input', 'layout-shift']});
```

### Asset Loading Strategy
```html
<!-- Critical CSS inline -->
<style>/* Critical above-fold styles */</style>

<!-- Preload important assets -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>

<!-- Lazy load images -->
<img src="placeholder.jpg" data-src="actual-image.jpg" loading="lazy" alt="Description">
```

### JavaScript Optimization
```javascript
// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);
```

## ♿ Accessibility Implementation

### Keyboard Navigation
```javascript
// Ensure all interactive elements are keyboard accessible
document.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' || e.key === ' ') {
        const target = e.target;
        if (target.hasAttribute('role') && target.getAttribute('role') === 'button') {
            target.click();
        }
    }
});
```

### Screen Reader Support
```html
<!-- Proper ARIA labels and descriptions -->
<nav role="navigation" aria-label="Main navigation">
    <ul>
        <li><a href="/" aria-current="page">Home</a></li>
        <li><a href="/about">About</a></li>
    </ul>
</nav>

<!-- Skip links for keyboard users -->
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### Focus Management
```css
/* Visible focus indicators */
:focus-visible {
    outline: 2px solid #005fcc;
    outline-offset: 2px;
}

/* Skip link styling */
.skip-link {
    position: absolute;
    top: -40px;
    left: 6px;
    background: #005fcc;
    color: white;
    padding: 8px;
    text-decoration: none;
    transition: top 0.3s;
}

.skip-link:focus {
    top: 6px;
}
```

## 🔍 SEO Implementation

### Meta Tags Template
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title - Site Name</title>
    <meta name="description" content="Compelling page description under 160 characters">
    
    <!-- Open Graph -->
    <meta property="og:title" content="Page Title">
    <meta property="og:description" content="Page description">
    <meta property="og:image" content="/images/og-image.jpg">
    <meta property="og:url" content="https://example.com/page">
    
    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Page Title">
    <meta name="twitter:description" content="Page description">
    <meta name="twitter:image" content="/images/twitter-image.jpg">
</head>
```

### Structured Data
```html
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "Site Name",
    "url": "https://example.com",
    "description": "Site description"
}
</script>
```

## 🧪 Testing Protocols

### Cross-Browser Testing
- **Chrome**: Latest stable version
- **Firefox**: Latest stable version
- **Safari**: Latest stable version (macOS/iOS)
- **Edge**: Latest stable version

### Device Testing
- **Mobile**: iPhone SE, iPhone 12, Android phones
- **Tablet**: iPad, Android tablets
- **Desktop**: 1920x1080, 1366x768, ultrawide monitors

### Performance Testing
```bash
# Lighthouse audits
npx lighthouse-cli https://site.com --output html --view

# Bundle analysis
npx webpack-bundle-analyzer build/static/js/*.js
```

### Accessibility Testing
```bash
# Automated accessibility testing
npx pa11y-ci --sitemap https://site.com/sitemap.xml

# Manual testing checklist
# - Keyboard navigation
# - Screen reader compatibility
# - Color contrast verification
# - Focus indicators
```

## 🚀 Deployment Standards

### Build Process
```json
{
  "scripts": {
    "build": "npm run optimize && npm run minify",
    "optimize": "imagemin src/images/* --out-dir=dist/images",
    "minify": "terser src/js/*.js -o dist/js/main.min.js",
    "deploy": "npm run build && gh-pages -d dist"
  }
}
```

### Performance Budget
- **JavaScript Bundle**: < 200KB gzipped
- **CSS Bundle**: < 50KB gzipped
- **Images**: Optimized, modern formats (WebP, AVIF)
- **Fonts**: Subset, preloaded, display: swap

## 📋 Quality Checklist

### Pre-Deployment
- [ ] Core Web Vitals scores: Good (green)
- [ ] Lighthouse Performance: > 90
- [ ] Lighthouse Accessibility: 100
- [ ] Lighthouse SEO: > 95
- [ ] Cross-browser testing completed
- [ ] Mobile responsiveness verified
- [ ] Keyboard navigation functional
- [ ] Screen reader compatibility confirmed

### Post-Deployment
- [ ] Real User Monitoring (RUM) data positive
- [ ] Search Console errors resolved
- [ ] Analytics tracking functional
- [ ] Performance monitoring active

---

*This module provides web development best practices that apply across all web projects while allowing for project-specific customizations.*