# Repository Evaluation: `agent-config`

After conducting a thorough review of the repository's structure, bash scripts, Markdown files, and documentation, here are my findings regarding the current state of `agent-config`, along with identified issues and recommendations for improvement.

## 1. Findings (Current State)

> [!NOTE]
> The repository exhibits an exceptionally strong and well-thought-out architecture for managing agentic AI configurations.

*   **Logical Architecture**: The repository successfully segregates concerns into `skills/` (role definitions), `instructions/` (ambient, always-on rules), `prompts/` (on-demand commands), `hooks/` (hard constraints), and `context/` (domain terminology).
*   **Universal vs. Project-Specific Pattern**: The strategy of keeping universal skills in `agent-config` and relying on `.local.md` overlays in destination projects is robust. It scales well across multiple codebases without duplicating foundational instructions.
*   **Safety & Protection**: The `update.sh` script safely updates upstream skills while explicitly ignoring `*.local.md` overlays, which perfectly preserves project context.
*   **Documentation**: The `README.md` files in every subdirectory clearly define the philosophy, constraints, and "when to use what," reducing ambiguity for maintaining the toolkit.

## 2. Issues Identified

While the core functionality for managing skills is excellent, there are gaps in tooling coverage for other asset types.

### Validation Gaps (`validate.sh`)
The validation script focuses solely on `skills/` and `hooks/`. It completely ignores the structural integrity of other critical directories:
*   **`prompts/`**: There is no validation to ensure that `.prompt.md` files contain the required YAML frontmatter (`name`, `description`, `agent`, `tools`).
*   **`instructions/`**: There is no validation to ensure `.instructions.md` files contain their required frontmatter (`name`, `description`, `applyTo`).
*   **README Tables**: The READMEs for prompts, context, and instructions are not validated against the actual files in those directories, meaning drift can occur if a file is added but the README is forgotten.

### Distribution Incompleteness (`init.sh` & `update.sh`)
*   The setup scripts (`init.sh` and `update.sh`) are highly localized to managing the `skills/` directory and generating `AGENTS.md`.
*   If a user wants to wire `hooks`, `instructions`, or `prompts` into a new project, there is no automated pathway. They are forced to manually invoke `cp` or `ln` commands and manually stitch JSON configurations (e.g., adding `PreToolUse` hook configurations into `.claude/settings.json`).

### Brittle README Checks
*   In `validate.sh`, the check for whether a skill is documented in a README relies on a simple `grep -q "\`$skill_name\`"`. While functional, this doesn't guarantee the skill is actually inside the Markdown table or that the table is formatted correctly.

## 3. Recommended Improvements

Based on the issues above, here are actionable improvements to level up the repository:

### 1. Expand `validate.sh` Coverage
Update `validate.sh` to enforce the same rigorous standards on instructions and prompts as it does on skills:
*   Add a check iterating over `instructions/*.instructions.md` to ensure `applyTo`, `name`, and `description` are present in the frontmatter.
*   Add a check iterating over `prompts/*.prompt.md` to verify the frontmatter.
*   Add coverage checks to ensure all instructions, templates, and prompts are listed in their respective directory `README.md` files.

### 2. Broaden Distribution Script Scope
Enhance `init.sh` to handle more than just skills:
*   Add optional flags like `--with-instructions` or `--with-prompts`.
*   Depending on the target environment, the script could copy `.instructions.md` files into a `.claude/instructions/` or `.cursor/rules/` directory in the downstream project.

### 3. Create a Hook Installer Script
Manually editing `.claude/settings.json` is error-prone. 
*   **Action**: Create a `scripts/install-hook.sh` (or integrate it into `init.sh`). This script could safely parse and inject the `PreToolUse` JSON configuration for `block-dangerous-git.sh` into a project's `.claude/settings.json` using `jq`.

### 4. Strengthen Validation Grepping
*   Instead of a flat `grep` for a backticked name, validate that the tables actually contain the correct number of rows relative to the files on disk. (This is a minor enhancement to make the tests more robust).
