/**
 * Site Configuration
 * Automatically determines the correct base URL based on the current hostname
 */
(function(window) {
    'use strict';
    
    // Determine the base URL based on the current hostname
    function getBaseURL() {
        var hostname = window.location.hostname;
        
        // Check if we're on the beta/dev site
        if (hostname.includes('maqsoftware-beta.netlify.app') || 
            hostname.includes('localhost') || 
            hostname.includes('127.0.0.1')) {
            return window.location.origin; // Use the current origin for beta/local
        }
        
        // Default to production site
        return 'https://maqsoftware.com';
    }
    
    // Create the global config object
    window.MAQConfig = {
        baseURL: getBaseURL(),
        
        // Helper function to get a full URL
        getURL: function(path) {
            // Remove leading slash if present to avoid double slashes
            var cleanPath = path.replace(/^\/+/, '');
            return this.baseURL + '/' + cleanPath;
        },
        
        // Helper function to check if we're on beta
        isBeta: function() {
            var hostname = window.location.hostname;
            return hostname.includes('maqsoftware-beta.netlify.app') || 
                   hostname.includes('localhost') || 
                   hostname.includes('127.0.0.1');
        },
        
        // Update meta tags for beta environment
        updateMetaTags: function() {
            if (!this.isBeta()) {
                return; // Only update on beta/dev sites
            }
            
            var currentPath = window.location.pathname;
            var betaURL = this.baseURL + currentPath;
            
            // Update canonical link
            var canonical = document.querySelector('link[rel="canonical"]');
            if (canonical && canonical.href.includes('maqsoftware.com')) {
                canonical.href = betaURL;
            }
            
            // Update Open Graph URL
            var ogURL = document.querySelector('meta[property="og:url"]');
            if (ogURL && ogURL.content.includes('maqsoftware.com')) {
                ogURL.content = betaURL;
            }
            
            // Update sitemap link
            var sitemap = document.querySelector('link[rel="sitemap"]');
            if (sitemap && sitemap.href.includes('maqsoftware.com')) {
                sitemap.href = this.baseURL + '/sitemap.xml';
            }
            
            // Update alternate language links
            var alternateLinks = document.querySelectorAll('link[rel="alternate"]');
            alternateLinks.forEach(function(link) {
                if (link.href && link.href.includes('maqsoftware.com')) {
                    var path = link.href.replace(/^https?:\/\/maqsoftware\.com/, '');
                    link.href = window.MAQConfig.baseURL + path;
                }
            });
            
            // Update og:image URLs to be absolute (keep them pointing to production for social sharing)
            // Beta images might not exist yet, so we keep production URLs for images
            
            console.log('Meta tags updated for beta environment');
        }
    };
    
    // Log the current configuration (can be removed in production)
    console.log('MAQConfig initialized:', window.MAQConfig.baseURL);
    
    // Automatically update meta tags when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            window.MAQConfig.updateMetaTags();
        });
    } else {
        // DOM already loaded
        window.MAQConfig.updateMetaTags();
    }
    
})(window);
