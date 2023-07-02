----Cleaning data in sql queries---


Select *
From PortfolioProject.dbo.NashvilleHousing


---Standardize DateFormat---

Select SaleDateCoverted ,CONVERT(Date,SaleDate)
--from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate=CONVERT(Date,SaleDate)

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted= CONVERT(Date,SaleDate)

---Populate property Address data---

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null

---breaking  out Address into indidvidual column(address,city,state)---
SELECT PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


Alter Table Nashvillehousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table Nashvillehousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing


Alter Table Nashvillehousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter Table Nashvillehousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table Nashvillehousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

---change Y and N to Yes and NO in "sold as vacant" field---
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant='Y' THEN 'YES'
     WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'YES'
     WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsVacant
	 END

---Remove duplicates---
WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER()OVER(
     PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				  UniqueID)row_num
FROM PortfolioProject.dbo.NashvilleHousing
---order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress


---Delete unused columns---
SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate