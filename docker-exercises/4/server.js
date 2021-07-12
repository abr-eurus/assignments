process.argv.forEach((val, index) => console.log(`${index}: ${val}`));

// sudo docker run -it --rm -v $(pwd):/root --workdir=/root node:6.9.1 node server.js abc