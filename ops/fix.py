import os
import re

# Directory containing your documents
doc_directory = "/Users/morgante/code/grit/stdlib/.grit"


def process_document(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # Find the index of the line containing "tags" and the frontmatter end
    tags_line_index = None
    frontmatter_end_index = None
    for index, line in enumerate(lines):
        if line.startswith("tags:"):
            print("Found tags", line.strip())
            tags_line_index = index
        if line.strip() == "---" and index > 0:
            frontmatter_end_index = index
            break

    # If tags are found
    if tags_line_index is not None:
        tags_line = lines.pop(tags_line_index)

        # The tags line looks like tags: #foo #bar #baz
        # Convert it to tags: [foo, bar, baz
        fixed_tags_line = re.sub(r"#(\w+)", r"\1", tags_line)

        # If there's a valid frontmatter section
        if frontmatter_end_index is not None:
            # Insert the tags line directly under the title in the frontmatter
            title_index = next(
                i for i, line in enumerate(lines[:frontmatter_end_index]) if line.startswith("title:")
            )
            lines.insert(
                title_index + 1, fixed_tags_line + "\n"
            )  # Ensure there's a newline after the tags
        else:
            # Create a basic frontmatter at the start of the file if it doesn't exist
            frontmatter = f"---\n{fixed_tags_line}---\n\n"
            lines = [frontmatter] + lines

        # Write the modified content back to the file
        with open(file_path, "w", encoding="utf-8") as file:
            file.writelines(lines)


def main():
    for root, dirs, files in os.walk(doc_directory):
        for file in files:
            print(f"Processing {file}")
            if file.endswith(".md"):  # Assuming markdown files
                process_document(os.path.join(root, file))


if __name__ == "__main__":
    main()