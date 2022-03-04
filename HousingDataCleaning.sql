/**
Data Cleaning in SQL Queries
**/

Select * from PortfolioProject.dbo.NashvillHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format
Select SaleDateConverted,CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvillHousing

update NashvillHousing 
set SaleDate = CONVERT(Date,SaleDate);


ALTER TABLE Nashvillhosing
Add SaleDateConverted Date;

Update NashvillHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------
--Populate Property Address data
 select * from
 PortfolioProject.dbo.NashvillHousing
 order by ParcelID;



 --- Using Joins to see nulls 

Select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvillHousing a 
join PortfolioProject.dbo.NashvillHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--update to remove nulls---
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvillHousing a
Join PortfolioProject.dbo.NashvillHousing b
	on a.ParcelID = a.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null;


------------------------------------------------------------------------------------------------------------

---Breaking out Address into Individual Columns (Address,City, State)

Select PropertyAddress 
from PortfolioProject.dbo.NashvillHousing

---Removing the comma in the address

Select 
SUBSTRING(PropertyAddress,1,CharIndex(',',PropertyAddress)-1 )
as Address
 , SUBSTRING(PropertyAddress,CharIndex(',',PropertyAddress)+1 ,LEN(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvillHousing

ALTER TABLE NashvillHousing
Add PropertySplitAddress Varchar(255);

update NashvillHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CharIndex(',',PropertyAddress)-1 )

ALTER TABLE NashvillHousing
Add PropertySplitCity Varchar(255);

update NashvillHousing 
SET PropertySplitCity =SUBSTRING(PropertyAddress,CharIndex(',',PropertyAddress)+1 ,LEN(PropertyAddress))


Select * from PortfolioProject.dbo.NashvillHousing


----OwnerAddress cleaning--
select OwnerAddress
from PortfolioProject.dbo.NashvillHousing

---Removing the comma in the owner address

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvillHousing


ALTER TABLE NashvillHousing
Add OwnerSplitAddress Varchar(255);

update NashvillHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

ALTER TABLE NashvillHousing
Add OwnerSplitCity Varchar(255);

update NashvillHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);


ALTER TABLE NashvillHousing
Add OwnerSplitState Varchar(255);

update NashvillHousing 
SET OwnerSplitState = 
PARSENAME(REPLACE(OwnerAddress,',','.'),1);

------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from PortfolioProject.dbo.NashvillHousing
group by SoldAsVacant
order by 2;


select SoldAsVacant 
, Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant ='N' Then 'No'
	else SoldAsVacant
	end
from PortfolioProject.dbo.NashvillHousing




Update NashvillHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant ='N' Then 'No'
	else SoldAsVacant
	end



-------------------------------------------------------------------------------------------
--Remove Duplicates


With RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
				partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
					UniqueID)row_num
from PortfolioProject.dbo.NashvillHousing
--order by ParcelID
)
Delete
from RowNumCTE
where row_num>1



--------------------------------------------------------------------------------------------------
---Delete Unused Columns

Alter TABLE PortfolioProject.dbo.NashvillHousing
Drop Column OwnerAddress,TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvillHousing
Drop Column SaleDate






