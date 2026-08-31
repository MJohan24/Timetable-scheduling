import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const dartFile = 'c:\\Users\\riyadh\\Downloads\\KAIACCES\\timetable\\lib\\shared\\widgets\\schematic_map_painter.dart';
  const content = fs.readFileSync(dartFile, 'utf-8');

  const regex = /StationData\([^)]*name:\s*'([^']*)'[^)]*code:\s*'([^']*)'/g;
  let match;

  const updates: { name: string; nodeCode: string }[] = [];

  while ((match = regex.exec(content)) !== null) {
    const name = match[1].trim();
    const nodeCode = match[2].trim();
    if (name && nodeCode) {
      updates.push({ name, nodeCode });
    }
  }

  console.log(`Found ${updates.length} stations with node codes in dart file.`);

  const allStations = await prisma.station.findMany();

  let updatedCount = 0;
  for (const update of updates) {
    // try to match by name (ignore case and spaces)
    const normalize = (s: string) => s.toLowerCase().replace(/[\s-]/g, '');
    const normalizedName = normalize(update.name);

    const dbStation = allStations.find(s => normalize(s.name) === normalizedName);
    if (dbStation) {
      await prisma.station.update({
        where: { id: dbStation.id },
        data: { nodeCode: update.nodeCode }
      });
      updatedCount++;
    } else {
      console.log(`Station not found in DB for name: ${update.name}`);
      // Create it just in case
      await prisma.station.create({
        data: {
          code: `AUTO_${update.nodeCode}`, // placeholder code so it's unique
          name: update.name,
          nodeCode: update.nodeCode,
        }
      });
      console.log(`Created new station for ${update.name}`);
    }
  }

  console.log(`Successfully updated ${updatedCount} existing stations and created the rest.`);
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
