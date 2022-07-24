/*

Cleaning Data in SQL Queries

*/

SELECT * 
FROM NashvilleHousing;

----------------------------------------------------------------------------------------------

--- Standardize date format


SELECT SaleDate, CONVERT(Date,SaleDate)
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate =  CONVERT(Date,SaleDate);

SELECT * 
FROM NashvilleHousing;

----------------------------------------------------------------------------------------------

--- Populate property address data

SELECT *
FROM NashvilleHousing
---WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) --- ISNULL command checks for nulls in specified columns and populates it with target column
FROM portfolio_projects.dbo.NashvilleHousing a
JOIN portfolio_projects.dbo.NashvilleHousing b --- join the table to itself
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolio_projects.dbo.NashvilleHousing a
JOIN portfolio_projects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 

----------------------------------------------------------------------------------------------

--- Breaking Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing
---WHERE PropertyAddress IS NULL
--ORDER BY ParcelID


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address, ---The -1 removes the comma. This contains the street number
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address --- This contains the city
FROM portfolio_projects.dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));


SELECT *
FROM NashvilleHousing;


SELECT OwnerAddress
FROM NashvilleHousing;

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3), --- Address
PARSENAME(REPLACE(OwnerAddress,',','.'), 2), --- City
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) --- State
FROM NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2);


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1);


SELECT * FROM NashvilleHousing;


----------------------------------------------------------------------------------------------

--- Change Y and N to Yes and No in "Sold as Vacant"

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



----------------------------------------------------------------------------------------------

--- Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
/*
DELETE
From RowNumCTE
Where row_num > 1
*/

SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHousing

----------------------------------------------------------------------------------------------

--- Delete unused columns


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;


SELECT * 
FROM NashvilleHousing;

----------------------------------------------------------------------------------------------

---

----------------------------------------------------------------------------------------------

---

----------------------------------------------------------------------------------------------