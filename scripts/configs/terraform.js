const { file, terraform } = require("../utils");
const path = require("path");

function TFConfig(env, root) {
    const tf_globals = {
        variables: [
            {
                description: "The AWS region to use for the project",
                value: env["AWS_REGION"],
                name: "aws_region",
                type: "string",
            },
            {
                description: "The GCP region to use for the project",
                value: env["GCP_REGION"],
                name: "gcp_region",
                type: "string",
            },
            {
                description: "The name of the project",
                value: env["PROJECT_NAME"],
                name: "project_name",
                type: "string",
            },
        ],
        locals: [
            {
                name: "common_tags",
                values: [
                    {
                        value: env["ENVIRONMENT"],
                        name: "Environment",
                        type: "string",
                    },
                    {
                        value: env["PROJECT_NAME"],
                        name: "Project",
                        type: "string",
                    },
                ],
            },
        ],
    };

    file.createOrModifyFile(
        path.join(root, "src", "globals.tf"),
        terraform.createTFVariables(tf_globals.variables) + "\n" + terraform.createTFLocals(tf_globals.locals)
    );
}

module.exports = {
    TFConfig,
};
