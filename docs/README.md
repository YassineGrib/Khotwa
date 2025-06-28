# Khotwa Website

A modern, responsive website for presenting the Khotwa mobile app with download functionality.

## 🚀 Features

- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Modern UI/UX**: Clean, professional design with smooth animations
- **Arabic RTL Support**: Fully optimized for Arabic language and right-to-left layout
- **Interactive Elements**: Smooth scrolling, hover effects, and form validation
- **Download Section**: Dedicated section for app downloads with store links
- **Contact Form**: Functional contact form with validation
- **SEO Optimized**: Meta tags and semantic HTML structure

## 📁 File Structure

```
website/
├── index.html          # Main HTML file
├── css/
│   └── style.css       # Custom styles and animations
├── js/
│   └── script.js       # Interactive functionality
├── images/
│   ├── app-mockup.png  # Hero section app image
│   ├── download-mockup.png # Download section image
│   └── README.md       # Image specifications
└── README.md           # This file
```

## 🛠️ Technologies Used

- **HTML5**: Semantic markup
- **CSS3**: Modern styling with CSS Grid and Flexbox
- **JavaScript (ES6+)**: Interactive functionality
- **Bootstrap 5**: Responsive framework
- **Font Awesome**: Icons
- **Google Fonts**: Cairo font family

## 🎨 Design Features

### Color Scheme
- **Primary**: #1976D2 (Blue)
- **Admin**: #4CAF50 (Green)
- **Doctor**: #009688 (Teal)
- **Patient**: #FF9800 (Orange)
- **Success**: #43A047 (Green)
- **Warning**: #FFC107 (Amber)
- **Error**: #E53935 (Red)

### Typography
- **Font Family**: Cairo (Google Fonts)
- **RTL Support**: Full right-to-left layout support
- **Responsive Text**: Scales appropriately on all devices

## 📱 Sections

1. **Hero Section**: Main landing area with app introduction
2. **Features Section**: Three cards showcasing features for patients, doctors, and admins
3. **Download Section**: App download links and information
4. **Contact Section**: Contact form and company information
5. **Footer**: Social media links and copyright

## 🚀 Getting Started

### Prerequisites
- A modern web browser
- Web server (optional, for local development)

### Installation

1. **Clone or download** the website files
2. **Add images** to the `images/` folder:
   - `app-mockup.png` (600x800px recommended)
   - `download-mockup.png` (500x700px recommended)
3. **Open** `index.html` in your browser

### Local Development

For local development, you can use any of these methods:

```bash
# Using Python
python -m http.server 8000

# Using Node.js (if you have http-server installed)
npx http-server

# Using PHP
php -S localhost:8000
```

Then visit `http://localhost:8000` in your browser.

## 🔧 Customization

### Colors
Edit the CSS variables in `css/style.css`:

```css
:root {
    --primary-color: #1976D2;
    --admin-color: #4CAF50;
    --doctor-color: #009688;
    --patient-color: #FF9800;
    /* ... other colors */
}
```

### Content
- **Text**: Edit the content in `index.html`
- **Images**: Replace images in the `images/` folder
- **Links**: Update download links and social media URLs

### Styling
- **Layout**: Modify `css/style.css`
- **Animations**: Adjust animation properties in CSS
- **Responsive**: Update media queries for different screen sizes

## 📊 Performance

- **Optimized Images**: Use compressed PNG/JPG images
- **Minified CSS/JS**: Consider minifying for production
- **CDN Resources**: Bootstrap and Font Awesome loaded from CDN
- **Lazy Loading**: Images can be optimized with lazy loading

## 🌐 Deployment

### Static Hosting
The website can be deployed to any static hosting service:

- **GitHub Pages**: Free hosting for public repositories
- **Netlify**: Drag and drop deployment
- **Vercel**: Fast deployment with Git integration
- **Firebase Hosting**: Google's hosting solution

### Steps for Deployment

1. **Prepare files**: Ensure all images are included
2. **Upload**: Upload all files to your hosting service
3. **Configure**: Set up custom domain if needed
4. **Test**: Verify all functionality works correctly

## 📱 Mobile Optimization

- **Responsive Design**: Automatically adapts to screen size
- **Touch-Friendly**: Large touch targets for mobile users
- **Fast Loading**: Optimized for mobile networks
- **RTL Support**: Proper Arabic text rendering

## 🔍 SEO Features

- **Meta Tags**: Proper title, description, and keywords
- **Semantic HTML**: Proper heading structure and landmarks
- **Alt Text**: Image descriptions for accessibility
- **Structured Data**: Ready for schema markup addition

## 🛡️ Security

- **Form Validation**: Client-side validation for contact form
- **XSS Prevention**: Proper HTML escaping
- **HTTPS Ready**: Works with SSL certificates

## 📞 Support

For questions or issues:
- Check the image specifications in `images/README.md`
- Ensure all files are in the correct folders
- Verify that all CDN resources are accessible

## 📄 License

This website is part of the Khotwa project. Please refer to the main project license.

---

**Note**: Remember to replace placeholder content and images with actual Khotwa app content before deployment. 