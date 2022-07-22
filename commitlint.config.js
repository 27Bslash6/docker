/**
 * This configures commitlint to use angular commits so that it aligns with the github action that is used to manage the tags (`mathieudutour/github-tag-action`).
 *
 * It is also using scope enum rule to ensure that commits to the modules repository are scoped to the correct module.
 *
 * It also is designed to require a Jira ticket to be included in the commit message however that feature is currently set to warn.
 *
 * When adding a new module, ensure that it is added to the third element of the scope-enum
 * rule. Do not remove scopes from this list unless the corresponding module is also removed.
 */

module.exports = {
  extends: ["@commitlint/config-conventional"],
  parserPreset: {
    parserOpts: {
      issuePrefixes: ["[A-Z]{1,8}-[0-9]{1,4}"],
    },
  },
  rules: {
    "header-max-length": [2, "always", 100],
    "references-empty": [1, "never"],
    "scope-case": [2, "always", "lower-case"],
    "scope-empty": [2, "never"],
    "scope-enum": [
      2,
      "always",
      [
        "automysqlbackup",
        "ubuntu",
        "repo",
      ]
    ],
    "subject-case": [0],
    "type-case": [2, "always", "lower-case"]
  },
};
