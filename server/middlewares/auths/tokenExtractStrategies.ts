function extractTokenFromHeader(headers: any) {
  if (headers.authorization && headers.authorization.startsWith("Bearer")) {
    let token;
    token = headers.authorization.split(" ")[1];
    return token;
  }
  throw new Error("Token not found");
}

export { extractTokenFromHeader };
