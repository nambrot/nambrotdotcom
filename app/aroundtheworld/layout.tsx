export default function AroundTheWorldLayout({
  children,
}: {
  children: React.ReactNode
}) {
  // This layout removes the default container styling for full-screen map
  return <>{children}</>;
}
