-- CreateEnum
CREATE TYPE "Role" AS ENUM ('GUEST', 'REGISTERED', 'ADMIN');

-- CreateEnum
CREATE TYPE "TicketStatus" AS ENUM ('PENDING', 'PAYMENT_PENDING', 'PAID', 'ACTIVE', 'USED', 'EXPIRED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'EXPIRED', 'CANCELLED');

-- CreateTable
CREATE TABLE "Station" (
    "id" TEXT NOT NULL,
    "slug" TEXT,
    "code" TEXT,
    "nodeCode" TEXT,
    "name" TEXT NOT NULL,
    "isTransit" BOOLEAN NOT NULL DEFAULT false,
    "isAccessible" BOOLEAN NOT NULL DEFAULT false,
    "isLrt" BOOLEAN NOT NULL DEFAULT false,
    "isKrl" BOOLEAN NOT NULL DEFAULT false,
    "isMrt" BOOLEAN NOT NULL DEFAULT false,
    "lineInfo" TEXT,
    "statusText" TEXT,
    "statusColor" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Station_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Line" (
    "id" TEXT NOT NULL,
    "slug" TEXT,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL,
    "serviceType" TEXT NOT NULL DEFAULT 'KRL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Line_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StationAlias" (
    "id" TEXT NOT NULL,
    "stationId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "normalized" TEXT NOT NULL,

    CONSTRAINT "StationAlias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StationNode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "mapId" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "mapX" DOUBLE PRECISION,
    "mapY" DOUBLE PRECISION,
    "stationId" TEXT NOT NULL,
    "lineId" TEXT NOT NULL,

    CONSTRAINT "StationNode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Schedule" (
    "id" TEXT NOT NULL,
    "sourceKey" TEXT,
    "trainName" TEXT NOT NULL,
    "route" TEXT NOT NULL,
    "departureTime" TEXT NOT NULL,
    "arrivalTime" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "trainType" TEXT NOT NULL,
    "isWeekend" BOOLEAN NOT NULL DEFAULT false,
    "stationId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RouteConnection" (
    "id" TEXT NOT NULL,
    "fromNodeId" TEXT NOT NULL,
    "toNodeId" TEXT NOT NULL,
    "travelTime" INTEGER NOT NULL,
    "fare" INTEGER NOT NULL,
    "serviceInfo" TEXT,
    "transitSteps" JSONB,
    "isTransfer" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RouteConnection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StationTransfer" (
    "id" TEXT NOT NULL,
    "fromStationId" TEXT NOT NULL,
    "toStationId" TEXT NOT NULL,
    "walkingTime" INTEGER NOT NULL DEFAULT 5,

    CONSTRAINT "StationTransfer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT,
    "password" TEXT,
    "name" TEXT,
    "phone" TEXT,
    "role" "Role" NOT NULL DEFAULT 'GUEST',
    "language" TEXT NOT NULL DEFAULT 'id',
    "accessibilityEnabled" BOOLEAN NOT NULL DEFAULT false,
    "notificationsEnabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ticket" (
    "id" TEXT NOT NULL,
    "publicCode" TEXT NOT NULL,
    "userId" TEXT,
    "contactEmail" TEXT,
    "contactPhone" TEXT,
    "scheduleId" TEXT,
    "originStationId" TEXT NOT NULL,
    "destinationStationId" TEXT NOT NULL,
    "passengerCount" INTEGER NOT NULL DEFAULT 1,
    "unitPrice" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "status" "TicketStatus" NOT NULL DEFAULT 'PAYMENT_PENDING',
    "qrCode" TEXT,
    "travelDate" TIMESTAMP(3) NOT NULL,
    "departureTime" TEXT,
    "arrivalTime" TEXT,
    "expiresAt" TIMESTAMP(3),
    "activatedAt" TIMESTAMP(3),
    "usedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancellationReason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Ticket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "ticketId" TEXT NOT NULL,
    "xenditInvoiceId" TEXT,
    "referenceId" TEXT NOT NULL,
    "xenditSessionId" TEXT,
    "xenditPaymentId" TEXT,
    "checkoutUrl" TEXT,
    "currency" TEXT NOT NULL DEFAULT 'IDR',
    "expiresAt" TIMESTAMP(3),
    "paymentMethod" TEXT,
    "amount" INTEGER NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WebhookEvent" (
    "id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "eventKey" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "processedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WebhookEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reminder" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "scheduleId" TEXT NOT NULL,
    "timeBefore" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reminder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'OPEN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatMessage" (
    "id" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "isFromAdmin" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_LineToStation" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Station_slug_key" ON "Station"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Station_code_key" ON "Station"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Line_slug_key" ON "Line"("slug");

-- CreateIndex
CREATE INDEX "StationAlias_normalized_idx" ON "StationAlias"("normalized");

-- CreateIndex
CREATE UNIQUE INDEX "StationAlias_stationId_normalized_key" ON "StationAlias"("stationId", "normalized");

-- CreateIndex
CREATE UNIQUE INDEX "StationNode_code_key" ON "StationNode"("code");

-- CreateIndex
CREATE UNIQUE INDEX "StationNode_mapId_key" ON "StationNode"("mapId");

-- CreateIndex
CREATE INDEX "StationNode_stationId_idx" ON "StationNode"("stationId");

-- CreateIndex
CREATE INDEX "StationNode_lineId_sequence_idx" ON "StationNode"("lineId", "sequence");

-- CreateIndex
CREATE UNIQUE INDEX "Schedule_sourceKey_key" ON "Schedule"("sourceKey");

-- CreateIndex
CREATE INDEX "RouteConnection_fromNodeId_idx" ON "RouteConnection"("fromNodeId");

-- CreateIndex
CREATE INDEX "RouteConnection_toNodeId_idx" ON "RouteConnection"("toNodeId");

-- CreateIndex
CREATE UNIQUE INDEX "RouteConnection_fromNodeId_toNodeId_key" ON "RouteConnection"("fromNodeId", "toNodeId");

-- CreateIndex
CREATE UNIQUE INDEX "StationTransfer_fromStationId_toStationId_key" ON "StationTransfer"("fromStationId", "toStationId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Ticket_publicCode_key" ON "Ticket"("publicCode");

-- CreateIndex
CREATE UNIQUE INDEX "Ticket_qrCode_key" ON "Ticket"("qrCode");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_xenditInvoiceId_key" ON "Payment"("xenditInvoiceId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_referenceId_key" ON "Payment"("referenceId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_xenditSessionId_key" ON "Payment"("xenditSessionId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_xenditPaymentId_key" ON "Payment"("xenditPaymentId");

-- CreateIndex
CREATE INDEX "Payment_ticketId_createdAt_idx" ON "Payment"("ticketId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "WebhookEvent_eventKey_key" ON "WebhookEvent"("eventKey");

-- CreateIndex
CREATE UNIQUE INDEX "_LineToStation_AB_unique" ON "_LineToStation"("A", "B");

-- CreateIndex
CREATE INDEX "_LineToStation_B_index" ON "_LineToStation"("B");

-- AddForeignKey
ALTER TABLE "StationAlias" ADD CONSTRAINT "StationAlias_stationId_fkey" FOREIGN KEY ("stationId") REFERENCES "Station"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StationNode" ADD CONSTRAINT "StationNode_stationId_fkey" FOREIGN KEY ("stationId") REFERENCES "Station"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StationNode" ADD CONSTRAINT "StationNode_lineId_fkey" FOREIGN KEY ("lineId") REFERENCES "Line"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Schedule" ADD CONSTRAINT "Schedule_stationId_fkey" FOREIGN KEY ("stationId") REFERENCES "Station"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteConnection" ADD CONSTRAINT "RouteConnection_fromNodeId_fkey" FOREIGN KEY ("fromNodeId") REFERENCES "StationNode"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteConnection" ADD CONSTRAINT "RouteConnection_toNodeId_fkey" FOREIGN KEY ("toNodeId") REFERENCES "StationNode"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StationTransfer" ADD CONSTRAINT "StationTransfer_fromStationId_fkey" FOREIGN KEY ("fromStationId") REFERENCES "Station"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StationTransfer" ADD CONSTRAINT "StationTransfer_toStationId_fkey" FOREIGN KEY ("toStationId") REFERENCES "Station"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "Schedule"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_originStationId_fkey" FOREIGN KEY ("originStationId") REFERENCES "Station"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ticket" ADD CONSTRAINT "Ticket_destinationStationId_fkey" FOREIGN KEY ("destinationStationId") REFERENCES "Station"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "Ticket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reminder" ADD CONSTRAINT "Reminder_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reminder" ADD CONSTRAINT "Reminder_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "Schedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LineToStation" ADD CONSTRAINT "_LineToStation_A_fkey" FOREIGN KEY ("A") REFERENCES "Line"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LineToStation" ADD CONSTRAINT "_LineToStation_B_fkey" FOREIGN KEY ("B") REFERENCES "Station"("id") ON DELETE CASCADE ON UPDATE CASCADE;
