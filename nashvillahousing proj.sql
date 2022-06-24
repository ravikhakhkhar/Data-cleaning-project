select * from nashvilleHousing

-- Standardize Date Format
select SaleDate,CONVERT(date,SaleDate) from nashvilleHousing -- It didnt worked so have to do alter method
update nashvilleHousing
set SaleDate=CONVERT(date,SaleDate)
alter table nashvilleHousing
add saleDateconverted date
update nashvilleHousing
set SaleDateconverted=CONVERT(date,SaleDate)


-- Populate Property Address data
select * 
from nashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull( a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing as a join nashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull( a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing as a join nashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress
from nashvilleHousing

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as city
from nashvilleHousing

alter table nashvilleHousing
add propertysplitAddress varchar(255)
update nashvilleHousing
set propertysplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table nashvilleHousing
add propertysplitCity varchar(255)
update nashvilleHousing
set propertysplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select propertysplitAddress,propertysplitCity from nashvilleHousing

--lets saperate the owner add,city
select OwnerAddress from nashvilleHousing


select
parsename(REPLACE(OwnerAddress,',','.') ,3),
parsename(REPLACE(OwnerAddress,',','.') ,2),
parsename(REPLACE(OwnerAddress,',','.') ,1)
from nashvilleHousing

alter table nashvilleHousing
add ownersplitaddress varchar(255)
update nashvilleHousing
set ownersplitaddress=parsename(REPLACE(OwnerAddress,',','.') ,3)

alter table nashvilleHousing
add ownersplitCity varchar(255)
update nashvilleHousing
set ownersplitCity=parsename(REPLACE(OwnerAddress,',','.') ,2)

alter table nashvilleHousing
add ownersplitState varchar(255)
update nashvilleHousing
set ownersplitState=parsename(REPLACE(OwnerAddress,',','.') ,1)


-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct SoldAsVacant,COUNT(SoldAsVacant) 
from nashvilleHousing 
group by SoldAsVacant order by 2


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 else SoldAsVacant end
from nashvilleHousing 
--where SoldAsVacant='Y'  

update nashvilleHousing
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
	 else SoldAsVacant end





-- Remove Duplicates
with rownumCTE as (
select *,
ROW_NUMBER() over (partition by parcelid, PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference order by uniqueid) as Row_num
from nashvilleHousing
)

select * from rownumCTE where Row_num>1

--Deleting unused columns
Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate