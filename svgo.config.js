module.exports = {
    plugins: [
      {
        name: 'preset-default',
        params: {
          overrides: {
            removeUnknownsAndDefaults: false,
            removeTitle: false,
            cleanupIds: false,
            removeViewBox: false,
          },
        },
      },
    ],
  };