function splitter(texts, ...params) {
    const pipeCount = texts.filter(t => t.includes('|')).length;
    const rows = params.length - pipeCount;
    const cols = params.length / rows;

    const result = [];
    for (const [i, param] of params.entries()) {
        const r = Math.floor(i / cols);
        const c = i % cols;

        result[r] = result[r] || [];
        result[r][c] = param;
    }

    return JSON.stringify(result, null, 4);
}

let input = [];
process.stdin.on('data', (data) => {
    input.push(data.toString());
});
process.stdin.on('end', () => {
    const spec = input.join('');
    const result = eval(`splitter${spec}`);
    console.log(result);
});
