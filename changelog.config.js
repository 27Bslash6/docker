let titles = {
  feat: "🚀 Features",
  fix: "🐛 Bug Fixes",
  perf: "🏎  Performance Improvement",
  docs: "📓 Documentation",
  style: "🎨 Style",
  refactor: "🔧 Code Refactoring",
  test: "🧪 Tests",
  build: "🏗️  Build System & Dependencies",
  chore: "🧹 Misc. Chores",
  ci: "⚗️ Continuous Integration",
};

module.exports = {
  writerOpts: {
    transform: (commit) => {
      console.log(commit);
      commit.type = titles[commit.type];
      commit.shortHash = commit.hash.substring(0, 7);
      return commit;
    },
    commitGroupsSort: (a, b) => {
      const tags = [
        "Breaking",
        titles["feat"],
        titles["fix"],
        titles["refactor"],
        titles["test"],
        titles["perf"],
        titles["docs"],
        titles["build"],
        titles["ci"],
        titles["chore"],
        titles["style"],
      ];
      let rankA = tags.indexOf(a.title);
      let rankB = tags.indexOf(b.title);
      return rankA - rankB;
    },
  },
};
