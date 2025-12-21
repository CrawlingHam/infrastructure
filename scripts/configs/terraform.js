const { file, terraform, string } = require("../utils");
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
                description: "The billing account ID to use for the project",
                value: env["GCP_BILLING_ACCOUNT_ID"],
                name: "gcp_billing_account_id",
                type: "string",
            },
            {
                description: "The name of the project",
                value: env["PROJECT_NAME"],
                name: "project_name",
                type: "string",
            },
            {
                description: "The capitalized name of the project",
                value: string.capitalize(env["PROJECT_NAME"]),
                name: "capitalized_project_name",
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
                    {
                        value: env["MAINTAINER"],
                        name: "Maintainer",
                        type: "string",
                    },
                ],
            },
        ],
    };

    file.createFile(
        path.join(root, "src", "globals.tf"),
        terraform.createTFVariables(tf_globals.variables) + "\n" + terraform.createTFLocals(tf_globals.locals)
    );
}

module.exports = {
    TFConfig,
};
