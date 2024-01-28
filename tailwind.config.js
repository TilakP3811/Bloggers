module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#4f616c",
        secondary: "#7995a7",
        third: "#9bbdd4",
        fourth: "#b4dffd",
        fifth: "#374249",
      },
    },
  },
  plugins: [require("flowbite/plugin")],
};
