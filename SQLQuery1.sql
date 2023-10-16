select *
from PortofolioProject..NashvilleHousing

-- Standardize Date Format

select SaleDate , CONVERT(Date,SaleDate)
from PortofolioProject..NashvilleHousing

update PortofolioProject..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


-- Populate Property Address data


Select *
From PortofolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

 --Breaking out Address into Individual Columns (Address, City, State)

 Select PropertyAddress
From PortofolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortofolioProject..NashvilleHousing

ALTER TABLE PortofolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortofolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE PortofolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortofolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortofolioProject..NashvilleHousing



Select OwnerAddress
From PortofolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortofolioProject..NashvilleHousing

ALTER TABLE PortofolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortofolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortofolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortofolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortofolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortofolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortofolioProject..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortofolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	From PortofolioProject..NashvilleHousing


	Update PortofolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



	   
-- Remove Duplicates

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

From PortofolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortofolioProject..NashvilleHousing


-- Delete Unused Columns

Select *
From PortofolioProject..NashvilleHousing


ALTER TABLE PortofolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
