/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      keyframes: {
        wiggle: {
          "0%, 100%": { transform: "rotate(-3deg)" },
          "50%": { transform: "rotate(3deg)" },
          "spin-slow": "spin 3s linear infinite",
        },
        animation: {
          wiggle: "wiggle 1s ease-in-out infinite",
        },
      },
    },
  },
  plugins: [],
};
