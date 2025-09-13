// Smooth scrolling for navigation links
document.querySelectorAll('nav a').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const targetId = this.getAttribute('href').substring(1);
        const targetSection = document.getElementById(targetId);

        window.scrollTo({
            top: targetSection.offsetTop - 60, // Adjust for fixed header
            behavior: 'smooth'
        });
    });
});

// Form submission handling
const contactForm = document.querySelector('#contact form');
if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Thank you for your message! (This is a demo)');
        this.reset();
    });
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('grammarForm');

    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent default form submission

        showLoading();

        // Get form data
        const formData = new FormData(form);

        // Send AJAX request
        fetch('', {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest' // Optional header to identify AJAX requests
            }
        })
            .then(response => response.text())
            .then(html => {
                // Create a temporary element to parse the HTML response
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // Extract the corrected text from the response
                const outputSection = doc.querySelector('.output-section');
                const outputText = doc.querySelector('.output-text');

                // Update the page with the new content
                if (outputSection && outputText) {
                    const existingOutput = document.querySelector('.output-section');
                    if (existingOutput) {
                        existingOutput.innerHTML = outputSection.innerHTML;
                    } else {
                        document.querySelector('.input-section').insertAdjacentHTML('afterend', outputSection.outerHTML);
                    }
                }

                hideLoading();
            })
            .catch(error => {
                console.error('Error:', error);
                hideLoading();
                alert('An error occurred. Please try again.');
            });
    });
});