type farmProducerType = Farmer | FarmingAssociation | WholeSaler | Vendor | Others | Nothing
type seafoodProducerType = Fishermen | WholeSaler | Vendor | Processed | Others | Nothing
type livestockProducerType = KoreanBeef | DirectImport | WholeSaler | Processed | Others | Nothing
type producerType =
  Farm(farmProducerType) | Seafood(seafoodProducerType) | Livestock(livestockProducerType)

type phoneNumberVerified = Verified | Unverified
