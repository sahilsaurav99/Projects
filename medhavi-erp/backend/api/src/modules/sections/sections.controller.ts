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
import { SectionsService } from './sections.service';
import { CreateSectionDto } from './dto/create-section.dto';
import { ListSectionsQueryDto } from './dto/list-sections.query';
import { UpdateSectionDto } from './dto/update-section.dto';

/**
 * SectionsController
 *
 * Permission keys mirror the terms module:
 *   sections.read   | sections.create | sections.update
 *   sections.delete | sections.restore
 */
@ApiTags('Sections')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'sections', version: '1' })
export class SectionsController {
  constructor(private readonly sections: SectionsService) {}

  @Get()
  @RequirePermissions('sections.read')
  @ApiOperation({ summary: 'List sections (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of sections.' })
  list(@Query() query: ListSectionsQueryDto) {
    return this.sections.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('sections.read')
  @ApiOperation({ summary: 'Get a single section by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.sections.findOne(id);
  }

  @Post()
  @RequirePermissions('sections.create')
  @ApiOperation({
    summary: 'Create a new section under a batch and term.',
  })
  create(@Body() dto: CreateSectionDto) {
    return this.sections.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('sections.update')
  @ApiOperation({ summary: 'Update a section (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateSectionDto,
  ) {
    return this.sections.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('sections.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a section (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.sections.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('sections.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted section.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.sections.restore(id);
  }
}
