import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { CampusesService } from './campuses.service';
import { CreateCampusDto } from './dto/create-campus.dto';
import { ListCampusesQueryDto } from './dto/list-campuses.query';
import { UpdateCampusDto } from './dto/update-campus.dto';

/**
 * CampusesController
 *
 * Permission keys mirror the institutes module:
 *   campuses.read | campuses.create | campuses.update
 *   campuses.delete | campuses.restore
 */
@ApiTags('Campuses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'campuses', version: '1' })
export class CampusesController {
  constructor(private readonly campuses: CampusesService) {}

  @Get()
  @RequirePermissions('campuses.read')
  @ApiOperation({ summary: 'List campuses (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of campuses.' })
  list(@Query() query: ListCampusesQueryDto) {
    return this.campuses.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('campuses.read')
  @ApiOperation({ summary: 'Get a single campus by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.campuses.findOne(id);
  }

  @Post()
  @RequirePermissions('campuses.create')
  @ApiOperation({ summary: 'Create a new campus under an institute.' })
  create(@Body() dto: CreateCampusDto) {
    return this.campuses.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('campuses.update')
  @ApiOperation({ summary: 'Update a campus (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCampusDto,
  ) {
    return this.campuses.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('campuses.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a campus (sets deletedAt, status=ARCHIVED).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.campuses.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('campuses.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted campus.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.campuses.restore(id);
  }
}
