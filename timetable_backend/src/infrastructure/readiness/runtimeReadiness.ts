export type RuntimeReadModel = 'routeGraph' | 'stationCatalog' | 'timetable';

export class RuntimeReadiness {
  private readonly ready = new Set<RuntimeReadModel>();

  constructor(private readonly required: readonly RuntimeReadModel[]) {}

  markReady(model: RuntimeReadModel) {
    this.ready.add(model);
  }

  markUnavailable(model: RuntimeReadModel) {
    this.ready.delete(model);
  }

  isReady() {
    return this.required.every((model) => this.ready.has(model));
  }

  missing() {
    return this.required.filter((model) => !this.ready.has(model));
  }
}

export function assertTransitReadModelsLoaded(input: {
  routeConnections: readonly unknown[];
  stations: readonly unknown[];
  timetableStationCount: number;
}) {
  if (input.routeConnections.length === 0) throw new Error('Route graph is empty.');
  if (input.stations.length === 0) throw new Error('Station catalog is empty.');
  if (input.timetableStationCount === 0) throw new Error('Timetable read model is empty.');
}

export const runtimeReadiness = new RuntimeReadiness([
  'routeGraph',
  'stationCatalog',
  'timetable',
]);
