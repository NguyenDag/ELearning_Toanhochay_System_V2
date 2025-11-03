// assets/js/main.js

class Carousel {
    constructor(selector = '.carousel-wrapper') {
        this.container = document.querySelector(selector);
        if (!this.container) {
            console.error(`Carousel Error: Container "${selector}" not found.`);
            return; // Stop if container doesn't exist
        }

        this.track = this.container.querySelector('.carousel-track');
        this.slides = this.container.querySelectorAll('.carousel-slide');
        this.dotsContainer = this.container.querySelector('.carousel-dots');
        this.prevBtn = this.container.querySelector('.carousel-prev');
        this.nextBtn = this.container.querySelector('.carousel-next');

        // Check if essential elements exist
        if (!this.track || this.slides.length === 0) {
            console.error("Carousel Error: Track or slides missing.");
            this.container.style.display = 'none'; // Hide broken carousel
            return;
        }

        this.currentIndex = 0;
        this.slideWidth = this.slides[0].getBoundingClientRect().width; // Get width dynamically
        this.autoplayInterval = null;
        this.autoplayDelay = 5000; // 5 seconds, can be customized

        this.dots = []; // Array to hold generated dots

        this.init();
    }

    init() {
        // Generate dots dynamically if container exists
        if (this.dotsContainer) {
            this.dotsContainer.innerHTML = ''; // Clear existing dots
            this.slides.forEach((_, index) => {
                const dot = document.createElement('span');
                dot.classList.add('dot');
                dot.dataset.slide = index; // Store index in data attribute
                dot.addEventListener('click', () => {
                    this.goToSlide(index);
                    this.resetAutoplay(); // Reset timer on manual click
                });
                this.dotsContainer.appendChild(dot);
                this.dots.push(dot); // Add to our array
            });
        } else {
             console.warn("Carousel Warning: Dots container not found.");
        }


        // Attach button events if buttons exist
        if (this.prevBtn) {
            this.prevBtn.addEventListener('click', () => {
                this.prevSlide();
                this.resetAutoplay(); // Reset timer on manual click
            });
        } else {
             console.warn("Carousel Warning: Previous button not found.");
        }

        if (this.nextBtn) {
            this.nextBtn.addEventListener('click', () => {
                this.nextSlide();
                this.resetAutoplay(); // Reset timer on manual click
            });
        } else {
            console.warn("Carousel Warning: Next button not found.");
        }


        // Initial update
        this.updateCarousel();

        // Autoplay
        this.startAutoplay();

        // Pause autoplay on hover
        this.container.addEventListener('mouseenter', () => this.stopAutoplay());
        this.container.addEventListener('mouseleave', () => this.startAutoplay());

        // Recalculate width on resize (important for responsive)
        window.addEventListener('resize', () => {
            this.slideWidth = this.slides[0].getBoundingClientRect().width;
            this.updateCarousel(); // Instantly jump to correct position
        });
    }

    updateCarousel(instant = false) {
        // Temporarily disable transition for instant jump (e.g., on resize)
        if (instant) {
            this.track.style.transition = 'none';
        } else {
            // Restore transition (make sure it matches CSS)
             this.track.style.transition = 'transform 0.5s ease-in-out';
        }

        const offset = -this.currentIndex * this.slideWidth;
        this.track.style.transform = `translateX(${offset}px)`; // Use px for width

        // Update dots
         if(this.dots.length > 0){
             this.dots.forEach((dot, index) => {
                 dot.classList.toggle('active', index === this.currentIndex);
             });
         }


        // Re-enable transition after instant jump if needed
        if (instant) {
            // Use a tiny timeout to allow the browser to apply the transform instantly
             setTimeout(() => {
                this.track.style.transition = 'transform 0.5s ease-in-out';
             }, 50);
        }
    }

    nextSlide() {
        this.currentIndex = (this.currentIndex + 1) % this.slides.length;
        this.updateCarousel();
    }

    prevSlide() {
        this.currentIndex = (this.currentIndex - 1 + this.slides.length) % this.slides.length;
        this.updateCarousel();
    }

    goToSlide(index) {
        if (index >= 0 && index < this.slides.length) {
            this.currentIndex = index;
            this.updateCarousel();
        }
    }

    startAutoplay() {
         // Clear any existing interval before starting a new one
        this.stopAutoplay();
        this.autoplayInterval = setInterval(() => this.nextSlide(), this.autoplayDelay);
    }

    stopAutoplay() {
        clearInterval(this.autoplayInterval);
        this.autoplayInterval = null; // Clear the interval ID
    }

    resetAutoplay() {
        this.stopAutoplay();
        this.startAutoplay();
    }
}

// Initialize carousel when page loads
document.addEventListener('DOMContentLoaded', () => {
    // Check if the carousel wrapper exists before creating an instance
    if (document.querySelector('.carousel-wrapper')) {
        new Carousel('.carousel-wrapper');
    }
    // You could initialize other components here too
});