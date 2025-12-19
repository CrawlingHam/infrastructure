function formatValue(value, type) {
    if (type !== "string") return value;

    if (/^(var\.|local\.|data\.|module\.)/.test(value)) return value;
    return `"${value}"`;
}

module.exports = {
    formatValue,
};
