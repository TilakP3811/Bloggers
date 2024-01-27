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
        primary: "#294B29",
        secondary: "#50623A",
        third: "#789461",
        fourth: "#DBE7C9",
      },
    },
  },
  plugins: [require("flowbite/plugin")],
};
