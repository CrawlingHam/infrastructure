const format = require("./format");

function createTFVariable(name, type, description = null, value = null) {
    const lines = [`variable "${name}" {`, `    type        = ${type}`];
    if (description) lines.push(`    description = "${description}"`);
    if (value) lines.push(`    default = "${value}"`);
    lines.push("}");

    return lines.join("\n");
}
function createTFLocal(local) {
    const lines = [`    ${local.name} = {`];
    for (let i = 0; i < local.values.length; i++) {
        const val = local.values[i];
        const formattedValue = format.formatValue(val.value, val.type);
        lines.push(`        ${val.name} = ${formattedValue}`);
    }
    lines.push(`    }`);

    return lines.join("\n");
}

function createTFLocals(locals) {
    const lines = ["\nlocals {"];
    for (let i = 0; i < locals.length; i++) lines.push(createTFLocal(locals[i]));
    lines.push(`}`);

    return lines.join("\n");
}

function createTFVariables(variables) {
    return variables.map((variable) => createTFVariable(variable.name, variable.type, variable.description, variable.value)).join("\n\n");
}

module.exports = {
    createTFVariable,
    createTFVariables,
    createTFLocal,
    createTFLocals,
};
