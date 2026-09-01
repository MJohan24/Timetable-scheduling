export class AsyncValueCache<T> {
  private value: Promise<T> | undefined;

  get(load: () => Promise<T>): Promise<T> {
    if (!this.value) {
      let value: Promise<T>;
      value = load().catch((error) => {
        if (this.value === value) this.value = undefined;
        throw error;
      });
      this.value = value;
    }
    return this.value;
  }

  clear() {
    this.value = undefined;
  }

  replace(value: T) {
    this.value = Promise.resolve(value);
  }
}
