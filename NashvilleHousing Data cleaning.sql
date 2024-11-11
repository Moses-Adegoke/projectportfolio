/*

Cleaning Data in SQL Queries for Nashville Housing poroject

*/

SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is no null 


SELECT parcelID, landuse,saledate,ownername
from nashvillehousing
where propertyaddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
SELECT saledate, CONVERT(date, saledate) as NewSaleDate
FROM nashvillehousing

UPDATE nashvillehousing
SET Newsaledate=convert(date, saledate)

ALTER TABLE NashvilleHousing
ADD NewSaleDate Date;

ALTER TABLE NashvilleHousing
DROP COLUMN Newsaledate



SELECT newsaledate
FROM NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT propertyaddress
FROM NashvilleHousing
WHERE propertyaddress is null

SELECT *
FROM NashvilleHousing
--where
 --propertyaddress is null
WHERE uniqueid=43076

SELECT *
FROM NashvilleHousing A
	JOIN Nashvillehousing B
	ON A.parcelID=B.ParcelID
	AND A.uniqueID<>B.uniqueID

SELECT a.uniqueid,a.parcelid,b.parcelid,a.propertyaddress,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
FROM NashvilleHousing A
	JOIN Nashvillehousing B
	ON A.parcelID=B.ParcelID
	AND A.uniqueID<>B.uniqueID
WHERE a.propertyaddress is not null


UPDATE a
SET PropertyAddress=ISNULL(a.propertyaddress,b.propertyaddress)
FROM NashvilleHousing A
JOIN Nashvillehousing B
	ON A.parcelID=B.ParcelID
	AND A.uniqueID<>B.uniqueID
WHERE a.propertyaddress is null

SELECT *
FROM nashvillehousing
WHERE propertyaddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT ownername, OwnerAddress
FROM NashvilleHousing
WHERE ownername is  null



SELECT
     parsename(replace(owneraddress,',','.'),3) Address,
     parsename(replace(owneraddress,',','.'),2) City,
     parsename(replace(owneraddress,',','.'),1) State
FROM NashvilleHousing

ALTER TABLE nashvillehousing
ADD Address varchar (250), City varchar (250), State varchar(254)

UPDATE nashvillehousing
SET Address= parsename(replace(owneraddress,',','.'),3),
	City=parsename(replace(owneraddress,',','.'),2),
	State=parsename(replace(owneraddress,',','.'),1) 


	--------------------------------------------------------------------------------------------------------------------------

-- Breaking out names into Individual Columns (First name, last name)

SELECT
	 PARSENAME(REPLACE(ownername,',','.'),2) FirstName,
	 PARSENAME(REPLACE(ownername,',','.'),1) LastName
FROM NashvilleHousing
WHERE ownername is not null

ALTER TABLE nashvillehousing
ADD FirstName varchar (250), LastName varchar (250)

UPDATE nashvillehousing
SET FirstName= PARSENAME(REPLACE(ownername,',','.'),2),
	LastName= PARSENAME(REPLACE(ownername,',','.'),1)

SELECT *
FROM NashvilleHousing









--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant
FROM nashvillehousing
WHERE SoldAsVacant = 'N'or SoldAsVacant= 'Y'


SELECT soldasvacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE soldasvacant
		END
FROM nashvillehousing

UPDATE NashvilleHousing
SET SoldAsVacant = 	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE soldasvacant
		END
		FROM nashvillehousing

SELECT *
FROM nashvillehousing




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH NashCTE AS (
   SELECT *,
   ROW_Number() Over(partition by parcelid ORDER BY  uniqueid)As RowNum
FROM nashvillehousing
)
SELECT*
FROM NashCTE
WHERE RowNum=1
ORDER BY propertyaddress







---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN  halfbath


















