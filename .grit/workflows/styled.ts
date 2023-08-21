import * as grit from '@getgrit/api';

export async function execute(options: grit.WorkflowOptions) {
  const transformResult = await grit.stdlib.transform(
    {
      objective: `You are an expert software engineer working on a migration from styled-components to Tailwind CSS.
      Given a styled component, you must migrate it a simple component with appropriate Tailwind classes.`,
      principles: ['Use the twMerge library to conditionally combine classes.'],
      model: 'slow',
      query: 'or { js"styled.$_`$_`", js"styled($_)`$_`" }',
      examples: [
        {
          input: `const StyledComponent = styled(({ backgroundColor, ...otherProps }) => (
  <MyContainer {...otherProps} />
))\`
  position: relative;
  background-color: \${({ backgroundColor }) => backgroundColor};
\`;`,
          replacements: [
            `({backgroundColor, ...otherProps}) => {
  const bgColorClass = backgroundColor ? \`bg-\${backgroundColor}\` : '';
  const className = twMerge(\`relative \${bgColorClass}\`);
  return (
    <MyContainer className={className} {...otherProps} />
  );
}`,
          ],
        },
      ],
    },
    {},
  );
  if (!transformResult.success) return transformResult;
  await grit.stdlib.apply(
    {
      query: `js"twMerge" as $mg where { $mg <: ensure_import_from(source=js"'tailwind-merge'") }`,
    },
    { paths: transformResult.paths },
  );
  await grit.stdlib.apply(
    {
      query: `js"import $_ from 'styled-components'" => .`,
    },
    { paths: transformResult.paths },
  );
  return {
    success: true,
    message: `Successfully migrated ${transformResult.paths.length} files.`,
  };
}
