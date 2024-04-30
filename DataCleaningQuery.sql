
-- Cleaning data in SQL Queries

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

--1. Changing Date Format
Select SalesDate 
From PortfolioProjects.dbo.NashvilleHousing


Alter table PortfolioProjects.dbo.NashvilleHousing
Add SalesDate Date;

update PortfolioProjects.dbo.NashvilleHousing
SET SalesDate = CONVERT(date, SaleDate)

--2. Populate Property Address

Select PropertyAddress
From PortfolioProjects.dbo.NashvilleHousing
where PropertyAddress is null

Select *
From PortfolioProjects.dbo.NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects.dbo.NashvilleHousing a
Join PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects.dbo.NashvilleHousing a
Join PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


--3. Breaking Address into Address, State and City

Select *
From PortfolioProjects.dbo.NashvilleHousing
order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProjects.dbo.NashvilleHousing


Alter table PortfolioProjects.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(225);

update PortfolioProjects.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table PortfolioProjects.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(225); 

update PortfolioProjects.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing



SELECT OwnerAddress
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProjects.dbo.NashvilleHousing

Alter table PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(225);

update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter table PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(225); 

update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(225); 

update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing



--4. Changing Y and N to word YES and NO

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

SELECT SoldAsVacant, 
CASE when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'NO'
	ELSE SoldAsVacant
	END
FROM PortfolioProjects.dbo.NashvilleHousing

update PortfolioProjects.dbo.NashvilleHousing
SET SoldAsVacant = 
CASE when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'NO'
	ELSE SoldAsVacant
	END



--5. Removing Duplicates 

--5.1#checking duplicates--
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProjects.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE 
WHERE row_num > 1
ORDER BY PropertyAddress

--#5.2Delecting the dupulicate#
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProjects.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE 
WHERE row_num > 1


--6. Delete unused columns

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing
order by ParcelID