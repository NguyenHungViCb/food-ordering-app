export type RouteInfo = {
  key: Symbol;
  path?: string;
  method?: string;
  payload?: any;
};

export type BasicResponseWithData<T> = {
  data: T;
  success: boolean;
  message?: string;
};

export type BasicResponseWithError = {
  message: string;
  success: boolean;
};

export type BasicResponse<T> =
  | BasicResponseWithData<T>
  | BasicResponseWithError;
