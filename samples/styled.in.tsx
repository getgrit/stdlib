import styled, { css } from 'styled-components';

export const Button = styled.a<{ $primary?: boolean }>`
  background: transparent;
  border-radius: 3px;

  &:hover {
    filter: brightness(0.85);
  }

  ${(props) =>
    props.$primary &&
    css`
    background: red;
    color: black;
  `}
`;
