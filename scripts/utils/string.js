function capitalize(str, capitalizeAll = false) {
    if (capitalizeAll) return str.toUpperCase();
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

module.exports = {
    capitalize,
};
